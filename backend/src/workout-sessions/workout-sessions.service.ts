import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { WorkoutSession } from './workout-session.entity';
import { CreateWorkoutSessionDto } from './dto/workout-session.dto';

@Injectable()
export class WorkoutSessionsService {
  constructor(
    @InjectModel(WorkoutSession.name)
    private workoutSessionModel: Model<WorkoutSession>,
  ) {}

  async create(userId: string, createDto: CreateWorkoutSessionDto): Promise<WorkoutSession> {
    const session = new this.workoutSessionModel({
      ...createDto,
      userId,
    });
    return session.save();
  }

  async findAll(userId: string): Promise<WorkoutSession[]> {
    return this.workoutSessionModel
      .find({ userId })
      .sort({ createdAt: -1 })
      .exec();
  }

  async findOne(id: string, userId: string): Promise<WorkoutSession> {
    const session = await this.workoutSessionModel.findOne({ _id: id, userId }).exec();
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
    const session = await this.workoutSessionModel.findOneAndDelete({ _id: id, userId }).exec();
    if (!session) {
      throw new NotFoundException('Workout session not found');
    }
  }
}
