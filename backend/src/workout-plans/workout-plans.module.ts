import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { WorkoutPlansService } from './workout-plans.service';
import { WorkoutPlansController } from './workout-plans.controller';
import { WorkoutPlan, WorkoutPlanSchema } from './workout-plan.entity';

@Module({
  imports: [MongooseModule.forFeature([{ name: WorkoutPlan.name, schema: WorkoutPlanSchema }])],
  controllers: [WorkoutPlansController],
  providers: [WorkoutPlansService],
  exports: [WorkoutPlansService],
})
export class WorkoutPlansModule {}
