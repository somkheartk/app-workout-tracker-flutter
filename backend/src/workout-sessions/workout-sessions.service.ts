import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { WorkoutSession } from './workout-session.entity';
import { CreateWorkoutSessionDto } from './dto/workout-session.dto';

@Injectable()
export class WorkoutSessionsService {
  constructor(
    @InjectRepository(WorkoutSession)
    private workoutSessionsRepository: Repository<WorkoutSession>,
  ) {}

  async create(userId: string, createDto: CreateWorkoutSessionDto): Promise<WorkoutSession> {
    const session = this.workoutSessionsRepository.create({
      ...createDto,
      userId,
    });
    return this.workoutSessionsRepository.save(session);
  }

  async findAll(userId: string): Promise<WorkoutSession[]> {
    return this.workoutSessionsRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, userId: string): Promise<WorkoutSession> {
    const session = await this.workoutSessionsRepository.findOne({
      where: { id, userId },
    });
    if (!session) {
      throw new NotFoundException('Workout session not found');
    }
    return session;
  }

  async getStats(userId: string) {
    const sessions = await this.findAll(userId);
    const totalWorkouts = sessions.length;
    const totalMinutes = sessions.reduce((sum, session) => sum + session.duration, 0);

    // Last 7 days
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const recentSessions = sessions.filter(
      session => new Date(session.startTime) >= sevenDaysAgo
    );

    return {
      totalWorkouts,
      totalMinutes,
      recentSessions: recentSessions.slice(0, 10),
    };
  }

  async remove(id: string, userId: string): Promise<void> {
    const session = await this.findOne(id, userId);
    await this.workoutSessionsRepository.remove(session);
  }
}
