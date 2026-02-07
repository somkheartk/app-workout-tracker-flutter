import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Group } from './group.entity';
import { CreateGroupDto, JoinGroupDto, AddActivityDto } from './dto/group.dto';

@Injectable()
export class GroupsService {
  constructor(
    @InjectRepository(Group)
    private groupsRepository: Repository<Group>,
  ) {}

  async create(userId: string, createDto: CreateGroupDto): Promise<Group> {
    const group = this.groupsRepository.create({
      ...createDto,
      adminId: userId,
      memberIds: [userId],
      activities: [],
    });
    return this.groupsRepository.save(group);
  }

  async findAll(userId: string): Promise<Group[]> {
    const allGroups = await this.groupsRepository.find();
    return allGroups.filter(group => group.memberIds.includes(userId));
  }

  async findOne(id: string, userId: string): Promise<Group> {
    const group = await this.groupsRepository.findOne({ where: { id } });
    if (!group) {
      throw new NotFoundException('Group not found');
    }
    if (!group.memberIds.includes(userId)) {
      throw new BadRequestException('You are not a member of this group');
    }
    return group;
  }

  async joinGroup(userId: string, joinDto: JoinGroupDto): Promise<Group> {
    const group = await this.groupsRepository.findOne({ where: { id: joinDto.groupId } });
    if (!group) {
      throw new NotFoundException('Group not found');
    }
    if (group.memberIds.includes(userId)) {
      throw new BadRequestException('You are already a member of this group');
    }
    group.memberIds.push(userId);
    return this.groupsRepository.save(group);
  }

  async addActivity(groupId: string, userId: string, activityDto: AddActivityDto): Promise<Group> {
    const group = await this.findOne(groupId, userId);
    group.activities.push({
      userId,
      ...activityDto,
      timestamp: new Date(),
    });
    return this.groupsRepository.save(group);
  }

  async leaveGroup(groupId: string, userId: string): Promise<void> {
    const group = await this.findOne(groupId, userId);
    if (group.adminId === userId) {
      throw new BadRequestException('Admin cannot leave the group. Transfer admin or delete the group.');
    }
    group.memberIds = group.memberIds.filter(id => id !== userId);
    await this.groupsRepository.save(group);
  }

  async remove(id: string, userId: string): Promise<void> {
    const group = await this.findOne(id, userId);
    if (group.adminId !== userId) {
      throw new BadRequestException('Only admin can delete the group');
    }
    await this.groupsRepository.delete(id);
  }
}
