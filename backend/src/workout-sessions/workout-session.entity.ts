import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

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

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;
}

export const WorkoutSessionSchema = SchemaFactory.createForClass(WorkoutSession);
