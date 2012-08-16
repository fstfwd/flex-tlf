////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package flashx.textLayout.property
{
	import flashx.textLayout.debug.assert;
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.tlf_internal;
		
	use namespace tlf_internal;
	
	[ExcludeClass]
	/** A property description with an integer value. @private */
	public class IntProperty extends Property
	{
		private var _minValue:int;
		private var _maxValue:int;
		
		public function IntProperty(nameValue:String, defaultValue:int, inherited:Boolean, category:String, minValue:int, maxValue:int)
		{
			super(nameValue, defaultValue, inherited, category);
			_minValue = minValue;
			_maxValue = maxValue;
		}
		
		public function get minValue():int
		{ return _minValue; }
		public function get maxValue():int
		{ return _maxValue; } 

		/** @private */
		public override function setHelper(currVal:*,newObject:*):*
		{ 
			if (newObject === null)
				newObject = undefined;
			
			if (newObject === undefined || newObject == FormatValue.INHERIT)
				return newObject;

			var newValNumber:Number = parseInt(newObject);
			if (isNaN(newValNumber))
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			var newVal:int = int(newValNumber);
			if (checkLowerLimit() && newVal < _minValue)
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			if (checkUpperLimit() && newVal > _maxValue)
			{
				Property.errorHandler(this,newObject);
				return currVal;
			}
			return newVal;
		}
		
		/** @private */
		public override function hash(val:Object, seed:uint):uint
		{ 
			if (val == FormatValue.INHERIT)
				return UintProperty.doHash(inheritHashValue, seed);
			CONFIG::debug { assert(!(val is String),"IntProperty.has non inherit string"); }
			return UintProperty.doHash(val as uint, seed);
		}
	}
}
