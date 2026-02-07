import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ timestamps: true })
export class WorkoutSession extends Document {
  @Prop({ required: true })
  planName: string;

  @Prop({ type: Array, required: true })
  completedExercises: any[];

  @Prop({ required: true })
  startTime: Date;

  @Prop({ required: true })
  endTime: Date;

  @Prop({ required: true })
  duration: number; // in minutes

  @Prop({ required: true })
  userId: string;
}

export const WorkoutSessionSchema = SchemaFactory.createForClass(WorkoutSession);
