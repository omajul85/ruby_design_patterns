# The Observer pattern
require 'observer'

# By building this general mechanism, we have removed the implicit coupling
# between the Employee class and the Payroll and TaxMan objects.
#
# Employee just forwards the news to any object that said that it was interested
# using the standard module Observable.
# The Observable module requires that you call the changed method (setting a flag to true)
# before you call notify_observers.
# Each call to notify_observers sets the changed flag back to false.

# Although we have used the analogy of the subject delivering news to its observer,
# we are really talking about one object calling a method on another object.

# The subject class: source of the news
class Employee
  include Observable

  attr_reader :title, :salary, :name

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end

# The observer classes: consumers of the news

class Payroll
  def update(changed_employee)
    puts("Cut a new check for #{changed_employee.name}!")
    puts("His salary is now #{changed_employee.salary}!")
  end
end

class TaxMan
  def update(changed_employee)
    puts("Send #{changed_employee.name} a new tax bill!")
  end
end

# Usage

payroll = Payroll.new
tax_man = TaxMan.new
fred = Employee.new('Fred', 'Crane Operator', 30000)

# The payroll department and the tax man will know all about it
fred.add_observer(payroll)
fred.add_observer(tax_man)
fred.salary = 55000
