import { Controller, Get, Post, Body, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { WorkoutSessionsService } from './workout-sessions.service';
import { CreateWorkoutSessionDto } from './dto/workout-session.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('workout-sessions')
export class WorkoutSessionsController {
  constructor(private readonly workoutSessionsService: WorkoutSessionsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Request() req, @Body() createDto: CreateWorkoutSessionDto) {
    return this.workoutSessionsService.create(req.user.userId, createDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll(@Request() req) {
    return this.workoutSessionsService.findAll(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('stats')
  getStats(@Request() req) {
    return this.workoutSessionsService.getStats(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  findOne(@Request() req, @Param('id') id: string) {
    return this.workoutSessionsService.findOne(id, req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Request() req, @Param('id') id: string) {
    return this.workoutSessionsService.remove(id, req.user.userId);
  }
}
