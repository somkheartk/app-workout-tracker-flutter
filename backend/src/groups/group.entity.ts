import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ timestamps: true })
export class Group extends Document {
  @Prop({ required: true })
  name: string;

  @Prop()
  description: string;

  @Prop({ required: true })
  adminId: string;

  @Prop({ type: [String], default: [] })
  memberIds: string[];

  @Prop({ type: Array, default: [] })
  activities: any[];
}

export const GroupSchema = SchemaFactory.createForClass(Group);
