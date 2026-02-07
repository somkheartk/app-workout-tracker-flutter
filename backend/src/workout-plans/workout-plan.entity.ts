import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ timestamps: true })
export class WorkoutPlan extends Document {
  @Prop({ required: true })
  name: string;

  @Prop()
  description: string;

  @Prop({ type: Array, required: true })
  exercises: any[];
}

export const WorkoutPlanSchema = SchemaFactory.createForClass(WorkoutPlan);
