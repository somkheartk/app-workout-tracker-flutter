import { Injectable, NotFoundException, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkoutPlan } from './workout-plan.entity';
import { CreateWorkoutPlanDto } from './dto/workout-plan.dto';

@Injectable()
export class WorkoutPlansService implements OnModuleInit {
  constructor(
    @InjectRepository(WorkoutPlan)
    private workoutPlansRepository: Repository<WorkoutPlan>,
  ) {}

  async onModuleInit() {
    await this.initializeDefaultPlans();
  }

  private async initializeDefaultPlans() {
    const count = await this.workoutPlansRepository.count();
    if (count === 0) {
      const defaultPlans = [
        {
          name: 'Beginner Full Body',
          description: 'Perfect for beginners starting their fitness journey',
          exercises: [
            { name: 'Push-ups', sets: 3, reps: 10, weight: 0 },
            { name: 'Squats', sets: 3, reps: 15, weight: 0 },
            { name: 'Plank', sets: 3, reps: 30, weight: 0 },
          ],
        },
        {
          name: 'Upper Body Strength',
          description: 'Build upper body strength and muscle',
          exercises: [
            { name: 'Bench Press', sets: 4, reps: 8, weight: 60 },
            { name: 'Pull-ups', sets: 3, reps: 8, weight: 0 },
            { name: 'Shoulder Press', sets: 3, reps: 10, weight: 30 },
            { name: 'Bicep Curls', sets: 3, reps: 12, weight: 15 },
          ],
        },
        {
          name: 'Lower Body Power',
          description: 'Develop powerful legs and glutes',
          exercises: [
            { name: 'Squats', sets: 4, reps: 10, weight: 80 },
            { name: 'Deadlifts', sets: 4, reps: 8, weight: 100 },
            { name: 'Lunges', sets: 3, reps: 12, weight: 0 },
            { name: 'Calf Raises', sets: 3, reps: 15, weight: 0 },
          ],
        },
      ];

      for (const plan of defaultPlans) {
        await this.workoutPlansRepository.save(plan);
      }
    }
  }

  async create(createWorkoutPlanDto: CreateWorkoutPlanDto): Promise<WorkoutPlan> {
    const plan = this.workoutPlansRepository.create(createWorkoutPlanDto);
    return this.workoutPlansRepository.save(plan);
  }

  async findAll(): Promise<WorkoutPlan[]> {
    return this.workoutPlansRepository.find();
  }

  async findOne(id: string): Promise<WorkoutPlan> {
    const plan = await this.workoutPlansRepository.findOne({ where: { id } });
    if (!plan) {
      throw new NotFoundException('Workout plan not found');
    }
    return plan;
  }

  async update(id: string, updateDto: Partial<CreateWorkoutPlanDto>): Promise<WorkoutPlan> {
    await this.workoutPlansRepository.update(id, updateDto);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const plan = await this.workoutPlansRepository.findOne({ where: { id } });
    if (!plan) {
      throw new NotFoundException('Workout plan not found');
    }
    await this.workoutPlansRepository.delete(id);
  }
}
