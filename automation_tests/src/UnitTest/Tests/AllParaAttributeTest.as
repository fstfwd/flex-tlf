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
package UnitTest.Tests
{
    import UnitTest.Fixtures.TestConfig;

    import flash.display.Sprite;

    import flashx.textLayout.elements.FlowLeafElement;
    import flashx.textLayout.elements.ParagraphElement;

    import flashx.textLayout.elements.TextFlow;

    import flashx.textLayout.formats.Category;
    import flashx.textLayout.formats.FormatValue;
    import flashx.textLayout.formats.TextLayoutFormat;
    import flashx.textLayout.property.BooleanPropertyHandler;
    import flashx.textLayout.property.EnumPropertyHandler;
    import flashx.textLayout.property.IntPropertyHandler;
    import flashx.textLayout.property.NumberPropertyHandler;
    import flashx.textLayout.property.PercentPropertyHandler;
    import flashx.textLayout.property.Property;
    import flashx.textLayout.tlf_internal;

    import org.flexunit.asserts.assertTrue;

    use namespace tlf_internal;

    public class AllParaAttributeTest extends AllAttributeTest
    {
        public function AllParaAttributeTest()
        {
            super("", "AllParaAttributeTest", TestConfig.getInstance());

            // Note: These must correspond to a Watson product area (case-sensitive)
            metaData.productArea = "Text Attributes";
            metaData.productSubArea = "Paragraph Attributes";
        }


        [Before]
        override public function setUpTest():void
        {
            super.setUpTest();
        }

        [After]
        override public function tearDownTest():void
        {
            super.tearDownTest();

            testProp = null;
            expectedValue = null;
            testValue = null;
        }

        /**
         * This builds testcases for properties in description that are Number types.  For each number property
         * testcases are built to set the value to the below the minimum value, step from the minimum value to the maximum value
         * and then above the maximum value.
         */
        [Test]
        public function testAllNumberPropsFromMinToMax():void
        {
            for each (testProp in TextLayoutFormat.description)
            {
                var handler:NumberPropertyHandler = testProp.findHandler(NumberPropertyHandler) as NumberPropertyHandler;

                if (handler && testProp.category == Category.PARAGRAPH)
                {
                    var minVal:Number = handler.minValue;
                    var maxVal:Number = handler.maxValue;
                    assertTrue(true, minVal < maxVal);
                    var delta:Number = (maxVal - minVal) / 10;
                    var includeInMinimalTestSuite:Boolean;

                    for (var value:Number = minVal - delta; ;)
                    {
                        expectedValue = value < minVal ? undefined : (value > maxVal ? undefined : value);
                        testValue = value;
                        // include in the minmalTest values below the range, min value, max value and values above the range
                        includeInMinimalTestSuite = (value <= minVal || value >= maxVal)

                        runOneParagraphAttributeTest();

                        if (value > maxVal)
                            break;
                        value += delta;
                    }
                }
            }
        }


        /**
         * This builds testcases for properties in attributes in description that are Int types.  For each number property
         * testcases are built to set the value to the below the minimum value, step from the minimum value to the maximum value
         * and then above the maximum value.
         */
        [Test]
        public function testAllIntPropsFromMinToMax():void
        {
            for each (testProp in TextLayoutFormat.description)
            {
                if (testProp.category == Category.PARAGRAPH)
                {
                    var handler:IntPropertyHandler = testProp.findHandler(IntPropertyHandler) as IntPropertyHandler;
                    if (handler)
                    {
                        var minVal:int = handler.minValue;
                        var maxVal:int = handler.maxValue;
                        assertTrue(true, minVal < maxVal);
                        var delta:int = (maxVal - minVal) / 10;
                        var includeInMinimalTestSuite:Boolean;

                        for (var value:Number = minVal - delta; ;)
                        {
                            expectedValue = value < minVal ? undefined : (value > maxVal ? undefined : value);
                            testValue = value;
                            // include in the minmalTest values below the range, min value, max value and values above the range
                            includeInMinimalTestSuite = (value <= minVal || value >= maxVal)

                            runOneParagraphAttributeTest();

                            if (value > maxVal)
                                break;
                            value += delta;
                        }
                    }
                }
            }
        }

        /**
         * This builds testcases for properties in description that are NumberOrPercent types.  For each number property
         * testcases are built to set the value to the below the minimum value, step from the minimum value to the maximum value
         * and then above the maximum value.  This is done first using the min/max number values and then the min/max percent values.
         */
        [Test]
        public function testAllNumberOrPercentPropsFromMinToMax():void
        {
            for each (testProp in TextLayoutFormat.description)
            {
                if (testProp.category == Category.PARAGRAPH)
                {
                    var numberHandler:NumberPropertyHandler = testProp.findHandler(NumberPropertyHandler) as NumberPropertyHandler;
                    var percentHandler:PercentPropertyHandler = testProp.findHandler(PercentPropertyHandler) as PercentPropertyHandler;
                    if (numberHandler && percentHandler)
                    {
                        var minVal:Number = numberHandler.minValue;
                        var maxVal:Number = numberHandler.maxValue;
                        assertTrue(true, minVal < maxVal);
                        var delta:Number = (maxVal - minVal) / 10;
                        var includeInMinimalTestSuite:Boolean;

                        for (var value:Number = minVal - delta; ;)
                        {
                            expectedValue = value < minVal ? undefined : (value > maxVal ? undefined : value);
                            testValue = value;

                            // include in the minmalTest values below the range, min value, max value and values above the range
                            includeInMinimalTestSuite = (value <= minVal || value >= maxVal)

                            runOneParagraphAttributeTest();
                            //ts.addTestDescriptor( new TestDescriptor (testClass, methodName, testConfig, null, prop, value, expectedValue, includeInMinimalTestSuite) );

                            if (value > maxVal)
                                break;
                            value += delta;
                        }

                        // repeat with percent values
                        minVal = percentHandler.minValue;
                        maxVal = percentHandler.maxValue;
                        assertTrue(true, minVal < maxVal);
                        delta = (maxVal - minVal) / 10;

                        for (value = minVal - delta; ;)
                        {
                            expectedValue = value < minVal ? undefined : (value > maxVal ? undefined : value.toString() + "%");
                            //ts.addTestDescriptor( new TestDescriptor (testClass, methodName, testConfig, null, prop, value.toString()+"%", expectedValue, true) );

                            testValue = value.toString() + "%";

                            runOneParagraphAttributeTest();

                            if (value > maxVal)
                                break;
                            value += delta;
                        }
                    }
                }
            }
        }

        /**
         * This builds testcases for properties in attributes in description that are Boolean types.  A testcase is generated
         * for true and false for the value.
         */
        [Test]
        public function testAllBooleanProps():void
        {
            for each (testProp in TextLayoutFormat.description)
            {
                if (testProp.category == Category.PARAGRAPH && testProp.findHandler(BooleanPropertyHandler) != null)
                {
                    expectedValue = testValue = true;
                    runOneParagraphAttributeTest();

                    expectedValue = testValue = false;
                    runOneParagraphAttributeTest();
                }
            }
        }


        /**
         * This builds testcases for properties in attributes in description that are Enumerated types types.  A testcase is generated
         * for each possible enumerated value
         */
        [Test]
        public function testAllEnumProps():void
        {
            var range:Object = null;
            var value:Object = null;

            for each (testProp in TextLayoutFormat.description)
            {
                // new code
                if (testProp.category == Category.PARAGRAPH)
                {
                    var handler:EnumPropertyHandler = testProp.findHandler(EnumPropertyHandler) as EnumPropertyHandler;
                    if (handler)
                    {
                        range = handler.range;
                        for (value in range)
                        {
                            if (value != FormatValue.INHERIT)
                            {
                                expectedValue = testValue = value;
                                runOneParagraphAttributeTest();
                            }
                        }
                        expectedValue = undefined;
                        testValue = "foo";
                        runOneParagraphAttributeTest();
                    }

                }
            }
        }

        /**
         * This builds testcases for setting all properties in description to inherit, null, undefined and an object.
         */
        [Test]
        public function testAllSharedValues():void
        {
            for each (testProp in TextLayoutFormat.description)
            {
                if (testProp.category == Category.PARAGRAPH)
                {

                    testValue = expectedValue = FormatValue.INHERIT;
                    runOneParagraphAttributeTest();

                    testValue = new Sprite();
                    expectedValue = undefined;
                    runOneParagraphAttributeTest();

                    testValue = null;
                    expectedValue = undefined;
                    runOneParagraphAttributeTest();

                    testValue = expectedValue = undefined;
                    runOneParagraphAttributeTest();

                    testValue = expectedValue = undefined;
                    clearFormatTest();
                }
            }
        }

        /**
         * Generic function to run one character attribute test.  Uses the selection manager to set the attributes on the entire flow at the span level
         * to value and then validates that the value is expectedValue.
         */
        public function runOneParagraphAttributeTest():void
        {
            if (testProp == null)
                return;	// must be set

            SelManager.selectAll();

            var ca:TextLayoutFormat = new TextLayoutFormat();
            assignmentHelper(ca);
            SelManager.applyParagraphFormat(ca);

            // expect that all FlowLeafElements have expectedValue as the properties value
            if (expectedValue !== undefined)
                assertTrue("not all ParagraphElements have the expected value", validateParagraphPropertyOnEntireFlow(SelManager.textFlow,testProp,expectedValue));
        }

        // support function to walk all FlowLeafElements and verify that prop is val
        static public function validateParagraphPropertyOnEntireFlow(textFlow:TextFlow, prop:Property,val:*):Boolean
        {
            var idx:int = 0;
            var elem:FlowLeafElement = textFlow.getFirstLeaf();
            assertTrue("either the first FlowLeafElement is null or the textFlow length is zero", elem != null || textFlow.textLength == 0);
            while (elem)
            {
                // error if elements have zero length
                assertTrue("The FlowLeafElement has zero length", elem.textLength != 0);

                var para:ParagraphElement = elem.getParagraph();

                // expect all values of prop to be supplied val
                if (para.format[prop.name] !== val)
                    return false;

                // inherit is never computed
                if ((val == FormatValue.INHERIT && para.computedFormat[prop.name] == val) || para.computedFormat[prop.name] === undefined)
                    return false;

                // skip to the next element
                var nextElem:FlowLeafElement = elem.getNextLeaf();
                var absoluteEnd:int = elem.getAbsoluteStart() + elem.textLength;
                if (nextElem == null)
                    assertTrue("absoluteEnd of the last FlowLeafElement is not the end of the textFlow", absoluteEnd == textFlow.textLength);
                else
                    assertTrue("the end of this FlowLeafElement does not equal the start of the next", absoluteEnd == nextElem.getAbsoluteStart());

                elem = nextElem;
            }
            return true;
        }
    }
}
