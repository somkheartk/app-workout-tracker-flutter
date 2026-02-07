import { IsNotEmpty, IsString, IsArray } from 'class-validator';

export class CreateWorkoutPlanDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsString()
  description?: string;

  @IsNotEmpty()
  @IsArray()
  exercises: any[];
}
