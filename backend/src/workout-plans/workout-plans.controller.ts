import { Controller, Get, Post, Body, Param, Put, Delete, UseGuards } from '@nestjs/common';
import { WorkoutPlansService } from './workout-plans.service';
import { CreateWorkoutPlanDto } from './dto/workout-plan.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('workout-plans')
export class WorkoutPlansController {
  constructor(private readonly workoutPlansService: WorkoutPlansService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() createWorkoutPlanDto: CreateWorkoutPlanDto) {
    return this.workoutPlansService.create(createWorkoutPlanDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll() {
    return this.workoutPlansService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.workoutPlansService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  update(@Param('id') id: string, @Body() updateDto: Partial<CreateWorkoutPlanDto>) {
    return this.workoutPlansService.update(id, updateDto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.workoutPlansService.remove(id);
  }
}
