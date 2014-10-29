using System;

namespace be.trojka.Ripit.Attributes
{
	public class SourceRefAttribute : Attribute
	{
		public SourceRefAttribute (int sourceRefId)
		{
			SourceRefId = sourceRefId;
		}

		public int SourceRefId {
			get;
			private set;
		}
	}
}

