using System;

namespace be.trojka.Ripit.Attributes
{
	public class DefaultValueAttribute : Attribute
	{
		public DefaultValueAttribute (string value)
		{
			Value = value;
		}

		public string Value {
			get;
			private set;
		}
	}
}

