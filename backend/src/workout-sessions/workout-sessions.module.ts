import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { WorkoutSessionsService } from './workout-sessions.service';
import { WorkoutSessionsController } from './workout-sessions.controller';
import { WorkoutSession, WorkoutSessionSchema } from './workout-session.entity';

@Module({
  imports: [MongooseModule.forFeature([{ name: WorkoutSession.name, schema: WorkoutSessionSchema }])],
  controllers: [WorkoutSessionsController],
  providers: [WorkoutSessionsService],
  exports: [WorkoutSessionsService],
})
export class WorkoutSessionsModule {}
