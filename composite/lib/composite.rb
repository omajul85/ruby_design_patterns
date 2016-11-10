# Component class
class Task
  attr_accessor :name, :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required
    0.0
  end

  def total_number_of_basic_task
    1
  end
end

# Leaf classes
class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super('Mix that batter up!')
  end

  def get_time_required
    3.0
  end
end

# A composite Task (base)
class CompositeTask < Task
  def initialize(name)
    super(name)
    @subtasks = []
  end

  def <<(task)
    @subtasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end

  def [](index)
    @sub_tasks[index]
  end

  def []=(index, new_value)
    @sub_tasks[index] = new_value
  end

  # Specifically, MakeBatterTask totals up all of the times required by its child tasks.
  def get_time_required
    @subtasks.inject(0.0) do |memo, task|
      memo + task.get_time_required
    end
  end

  def total_number_of_basic_task
    @subtasks.inject(0.0) do |memo, task|
      memo + task.total_number_of_basic_task
    end
  end
end

# A composite task using the code factor out before
class MakeBatterTask < CompositeTask
  def initialize
    super('Make batter')
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(MixTask.new)
  end
end

# Composite task can have composite sub tasks as well !!!
