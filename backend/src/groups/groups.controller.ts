import { Controller, Get, Post, Body, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { GroupsService } from './groups.service';
import { CreateGroupDto, JoinGroupDto, AddActivityDto } from './dto/group.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('groups')
export class GroupsController {
  constructor(private readonly groupsService: GroupsService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Request() req, @Body() createDto: CreateGroupDto) {
    return this.groupsService.create(req.user.userId, createDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll(@Request() req) {
    return this.groupsService.findAll(req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  findOne(@Request() req, @Param('id') id: string) {
    return this.groupsService.findOne(id, req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Post('join')
  joinGroup(@Request() req, @Body() joinDto: JoinGroupDto) {
    return this.groupsService.joinGroup(req.user.userId, joinDto);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/activity')
  addActivity(@Request() req, @Param('id') id: string, @Body() activityDto: AddActivityDto) {
    return this.groupsService.addActivity(id, req.user.userId, activityDto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id/leave')
  leaveGroup(@Request() req, @Param('id') id: string) {
    return this.groupsService.leaveGroup(id, req.user.userId);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Request() req, @Param('id') id: string) {
    return this.groupsService.remove(id, req.user.userId);
  }
}
