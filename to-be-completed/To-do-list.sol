//SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;

/// @notice To-do-list
/// @author dura.eth
contract Todo {
    address owner;
    /*
    Create struct called task 
    The struct has 3 fields : id,title,Completed
    Choose the appropriate variable type for each field.
    */
    struct Task {
        uint256 id;
        string title;
        bool completed;
    }

    ///Create a counter to keep track of added tasks
    uint256 taskCount;

    /*
    create a mapping that maps the counter created above with the struct taskcount
    key should of type integer
    */
    mapping(uint256 => Task) public tasks;

    /*
    Define a constructor
    the constructor takes no arguments
    Set the owner to the creator of the contract
    Set the counter to  zero
    */
    /// @dev constructor to set the owner and add some initial cities
    constructor() {
        owner = msg.sender;
        taskCount = 0;
    }

    /*
    Define 2 events
    taskadded should provide information about the title of the task and the id of the task
    taskcompleted should provide information about task status and the id of the task
    */
    event taskAdded(string taskTitle, uint256 taskId);
    event taskCompleted(bool taskStatus, uint256 taskId);

    /*
        Create a modifier that throws an error if the msg.sender is not the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    /*
    Define a function called addTask()
    This function allows anyone to add task
    This function takes one argument , title of the task
    Be sure to check :
    taskadded event is emitted
     */
    /// @notice Anyone can add new task
    /// @dev add new task
    /// @param _title title of the task
    function addTask(string memory _title) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _title, false);
        emit taskAdded(_title, taskCount);
    }

    /*Define a function  to get total number of task added in this contract*/
    /// @notice You can get the total number of tasks
    /// @dev get the total number of tasks
    /// @return taskCount total number of tasks
    function getTaskCount() public view returns (uint256) {
        return taskCount;
    }

    /**
    Define a function gettask()
    This function takes 1 argument ,task id and 
    returns the task name ,task id and status of the task
     */
    /// @notice You can get the task details
    /// @dev get the task details
    /// @param _taskId id of the task
    /// @return taskTitle title of the task
    /// @return taskId id of the task
    /// @return taskStatus status of the task
    function getTask(
        uint256 _taskId
    ) public view returns (string memory, uint256, bool) {
        Task memory tsk = tasks[_taskId];
        return (tsk.title, tsk.id, tsk.completed);
    }

    /**Define a function marktaskcompleted()
    This function takes 1 argument , task id and 
    set the status of the task to completed 
    Be sure to check:
    taskcompleted event is emitted
     */
    // Considering the task is completed only by the owner
    /// @notice Owner can mark the task as completed
    /// @dev mark the task as completed
    /// @param _taskId id of the task
    function markTaskCompleted(uint256 _taskId) public onlyOwner {
        Task memory tsk = tasks[_taskId];
        tsk.completed = true;
        tasks[_taskId] = tsk;
        emit taskCompleted(tsk.completed, _taskId);
    }

    receive() external payable {}

    fallback() external payable {}
}
