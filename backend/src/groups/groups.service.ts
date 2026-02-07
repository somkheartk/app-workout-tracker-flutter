import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Group } from './group.entity';
import { CreateGroupDto, JoinGroupDto, AddActivityDto } from './dto/group.dto';

@Injectable()
export class GroupsService {
  constructor(
    @InjectModel(Group.name)
    private groupModel: Model<Group>,
  ) {}

  async create(userId: string, createDto: CreateGroupDto): Promise<Group> {
    const group = new this.groupModel({
      ...createDto,
      adminId: userId,
      memberIds: [userId],
      activities: [],
    });
    return group.save();
  }

  async findAll(userId: string): Promise<Group[]> {
    return this.groupModel.find({ memberIds: userId }).exec();
  }

  async findOne(id: string, userId: string): Promise<Group> {
    const group = await this.groupModel.findById(id).exec();
    if (!group) {
      throw new NotFoundException('Group not found');
    }
    if (!group.memberIds.includes(userId)) {
      throw new BadRequestException('You are not a member of this group');
    }
    return group;
  }

  async joinGroup(userId: string, joinDto: JoinGroupDto): Promise<Group> {
    const group = await this.groupModel.findById(joinDto.groupId).exec();
    if (!group) {
      throw new NotFoundException('Group not found');
    }
    if (group.memberIds.includes(userId)) {
      throw new BadRequestException('You are already a member of this group');
    }
    group.memberIds.push(userId);
    return group.save();
  }

  async addActivity(groupId: string, userId: string, activityDto: AddActivityDto): Promise<Group> {
    const group = await this.findOne(groupId, userId);
    group.activities.push({
      userId,
      ...activityDto,
      timestamp: new Date(),
    });
    return group.save();
  }

  async leaveGroup(groupId: string, userId: string): Promise<void> {
    const group = await this.findOne(groupId, userId);
    if (group.adminId === userId) {
      throw new BadRequestException('Admin cannot leave the group. Transfer admin or delete the group.');
    }
    group.memberIds = group.memberIds.filter(id => id !== userId);
    await group.save();
  }

  async remove(id: string, userId: string): Promise<void> {
    const group = await this.findOne(id, userId);
    if (group.adminId !== userId) {
      throw new BadRequestException('Only admin can delete the group');
    }
    await this.groupModel.findByIdAndDelete(id).exec();
  }
}
