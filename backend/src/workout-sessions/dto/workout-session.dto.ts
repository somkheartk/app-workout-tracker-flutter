import { IsNotEmpty, IsString, IsArray, IsDateString, IsNumber } from 'class-validator';

export class CreateWorkoutSessionDto {
  @IsNotEmpty()
  @IsString()
  planName: string;

  @IsNotEmpty()
  @IsArray()
  completedExercises: any[];

  @IsNotEmpty()
  @IsDateString()
  startTime: Date;

  @IsNotEmpty()
  @IsDateString()
  endTime: Date;

  @IsNotEmpty()
  @IsNumber()
  duration: number;
}
