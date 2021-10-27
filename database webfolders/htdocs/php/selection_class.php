<?php
class Selection{
	//Variables
	public $itemType;
	public $checkOut;
	public $checkIn;

	//Constructor
	function __construct($Type, $Out, $In){
		$this->itemType = $Type;
		$this->checkOut = $Out;
		$this->checkIn = $In;
	}
}
?>