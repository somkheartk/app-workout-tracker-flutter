import { IsNotEmpty, IsString, IsUUID } from 'class-validator';

export class CreateGroupDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsString()
  description?: string;
}

export class JoinGroupDto {
  @IsNotEmpty()
  @IsUUID()
  groupId: string;
}

export class AddActivityDto {
  @IsNotEmpty()
  @IsString()
  workoutName: string;

  @IsNotEmpty()
  duration: number;
}
