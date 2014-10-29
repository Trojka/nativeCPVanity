using System;
using System.Collections.Generic;
//using System.Collections.Concurrent;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using be.trojka.Ripit.Attributes;

namespace be.trojka.Ripit.Core
{
	public class ObjectBuilder
	{
		string pageText = "";

		public IList<T> FillList<T>(IList<T> listToFill, Dictionary<String, String> paramList, Func<T> itemFactory ) where T: class
		{
			Dictionary<int, string> globalSources = GetSources(listToFill, paramList);

			Type objectType = listToFill.GetType();
			Attribute[] objectAttrs = (System.Attribute[])objectType.GetCustomAttributes (false);
			CollectionCaptureAttribute captureAttribute = objectAttrs.OfType<CollectionCaptureAttribute> ().SingleOrDefault ();
			if(captureAttribute == null)
			{
				return listToFill;
			}

			MatchCollection matches = Regex.Matches(globalSources[captureAttribute.Index], captureAttribute.CaptureExpression, RegexOptions.IgnoreCase);
			foreach (Match match in matches) {
				Dictionary<int, string> targetSources = new Dictionary<int, string>();
				targetSources.Add (0, match.Groups [0].Value);

				T objectToFill = itemFactory ();

				T filledObject = (T)FillFromSources(objectToFill, targetSources);

				listToFill.Add (filledObject);
			}

			return listToFill;
		}

        public Task<T> FillObjectAsync<T>(T objectToFill, Dictionary<String, String> paramList) where T : class
        {
            Type objectType = objectToFill.GetType();
            Dictionary<int, string> globalSources = new Dictionary<int, string>();
            Dictionary<int, string> sourceURLs = GetSourceURLs(objectType, paramList);
            ManualResetEvent allDone = new ManualResetEvent(true);

            //HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(sourceURLs[1]);
            //IAsyncResult result = myReq.BeginGetResponse(null, Tuple.Create<int, HttpWebRequest>(1, myReq));
            //return Task.Factory.FromAsync(result, ar =>
            //{
            //    Tuple<int, HttpWebRequest> request2IdMap = result.AsyncState as Tuple<int, HttpWebRequest>;
            //    HttpWebRequest request = request2IdMap.Item2;
            //    Object responseAsObject = request.EndGetResponse(ar);
            //    HttpWebResponse response = responseAsObject as HttpWebResponse;
            //    using (System.IO.Stream responseStream = response.GetResponseStream())
            //    {
            //        using (var reader = new System.IO.StreamReader(responseStream))
            //        {
            //            pageText = reader.ReadToEnd();

            //            allDone.WaitOne();
            //            allDone.Reset();

            //            if (!globalSources.ContainsKey(request2IdMap.Item1))
            //            {
            //                globalSources.Add(request2IdMap.Item1, pageText);
            //            }

            //            allDone.Set();
            //        }
            //    }
            //});



            var loadPagesTasks = sourceURLs.Select(
                src =>
                {
                    HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(src.Value);
                    IAsyncResult result = myReq.BeginGetResponse(null, Tuple.Create<int, HttpWebRequest>(src.Key, myReq));
                    return Task.Factory.FromAsync(result, ar =>
                        {
                            Tuple<int, HttpWebRequest> request2IdMap = result.AsyncState as Tuple<int, HttpWebRequest>;
                            HttpWebRequest request = request2IdMap.Item2;
                            Object responseAsObject = request.EndGetResponse(ar);
                            HttpWebResponse response = responseAsObject as HttpWebResponse;
                            using (System.IO.Stream responseStream = response.GetResponseStream())
                            {
                                using (var reader = new System.IO.StreamReader(responseStream))
                                {
                                    pageText = reader.ReadToEnd();

                                    allDone.WaitOne();
                                    allDone.Reset();

                                    if (!globalSources.ContainsKey(request2IdMap.Item1))
                                    {
                                        globalSources.Add(request2IdMap.Item1, pageText);
                                    }

                                    allDone.Set();
                                }
                            }
                        });
                }).ToList();

            return Task.Factory.ContinueWhenAll(loadPagesTasks.ToArray(), tasks => FillFromSources(objectToFill, globalSources));

        }

        public object Fill(object objectToFill, Dictionary<String, String> paramList)
        {

            Dictionary<int, string> globalSources = GetSources(objectToFill, paramList);

            return FillFromSources(objectToFill, globalSources);
        }

        public Dictionary<int, List<PropertyInfo>> GetPropertiesBySource(Type objectType)
        {
            Dictionary<int, List<PropertyInfo>> sourceId2PropertyMap = new Dictionary<int, List<PropertyInfo>>();

            foreach (PropertyInfo property in objectType.GetProperties())
            {
                Attribute[] propertyAttrs = (System.Attribute[])property.GetCustomAttributes(typeof(SourceRefAttribute), false);
                if (propertyAttrs == null || propertyAttrs.Length == 0)
                    continue;

                SourceRefAttribute sourceRef = (SourceRefAttribute)propertyAttrs[0];
                if (!sourceId2PropertyMap.ContainsKey(sourceRef.SourceRefId))
                {
                    sourceId2PropertyMap.Add(sourceRef.SourceRefId, new List<PropertyInfo>());
                }

                if (!sourceId2PropertyMap[sourceRef.SourceRefId].Contains(property))
                {
                    sourceId2PropertyMap[sourceRef.SourceRefId].Add(property);
                }
            }

            return sourceId2PropertyMap;
        }

        private Dictionary<int, string> GetSourceURLs(Type objectType, Dictionary<String, String> paramList)
        {
            Dictionary<int, string> sourceURLs = new Dictionary<int, string>();

            Object[] objectAttrs = (System.Object[])objectType.GetCustomAttributes(false);
            foreach (HttpSourceAttribute httpSource in objectAttrs.ToList().OfType<HttpSourceAttribute>())
            {

                int startOfParam = httpSource.Url.LastIndexOf("?");
                string mainUrl = httpSource.Url.Substring(0, startOfParam);
                string paramString = httpSource.Url.Substring(startOfParam + 1);

                bool isFirsParam = true;
                foreach (string param in paramString.Split(new string[] { "&" }, StringSplitOptions.RemoveEmptyEntries))
                {
                    string paramName = param.Substring(0, param.IndexOf("="));
                    string paramValuePlaceHolder = param.Substring(param.IndexOf("=") + 1);
                    if (paramList.ContainsKey(paramValuePlaceHolder))
                    {
                        mainUrl = mainUrl + (isFirsParam ? "?" : "&") + paramName + "=" + paramList[paramValuePlaceHolder];
                    }
                    else
                    {
                        mainUrl = mainUrl + (isFirsParam ? "?" : "&") + param;
                    }

                    isFirsParam = false;
                }

                sourceURLs.Add(httpSource.Id, mainUrl);
            }

            return sourceURLs;
        }

		private Dictionary<int, string> GetSources(object objectToFill, Dictionary<String, String> paramList)
		{
			Dictionary<int, string> globalSources = new Dictionary<int, string> ();

			Type objectType = objectToFill.GetType();
			Object[] objectAttrs = (System.Object[])objectType.GetCustomAttributes (false);
			foreach (HttpSourceAttribute httpSource in objectAttrs.ToList().OfType<HttpSourceAttribute>()) {

				int startOfParam = httpSource.Url.LastIndexOf ("?");
				string mainUrl = httpSource.Url.Substring (0, startOfParam);
				string paramString = httpSource.Url.Substring (startOfParam + 1);

				bool isFirsParam = true;
				foreach (string param in paramString.Split(new string[]{"&"}, StringSplitOptions.RemoveEmptyEntries)) {
					string paramName = param.Substring(0, param.IndexOf("="));
					string paramValuePlaceHolder = param.Substring(param.IndexOf("=") + 1);
					if(paramList.ContainsKey(paramValuePlaceHolder)) {
						mainUrl = mainUrl + (isFirsParam?"?":"&") + paramName + "=" + paramList[paramValuePlaceHolder];
					}
					else {
						mainUrl = mainUrl + (isFirsParam ? "?" : "&") + param;
					}

					isFirsParam = false;
				}

				HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create (mainUrl);
				IAsyncResult result = myReq.BeginGetResponse (new AsyncCallback (FinishWebRequest), myReq);

				//allDone.WaitOne ();
				//allDone.Reset ();

				globalSources.Add (httpSource.Id, pageText);
			}

			return globalSources;
		}

        public T FillFromSources<T>(T objectToFill, Dictionary<int, string> globalSources) where T : class
        {
            return FillFromSources(objectToFill as object, globalSources) as T;
        }

		private object FillFromSources(object objectToFill, Dictionary<int, string> globalSources)
		{
			Type objectType = objectToFill.GetType();
			foreach (PropertyInfo property in objectType.GetProperties ()) {
				pageText = "";

                Object[] propertyAttrs = property.GetCustomAttributes(false);
				if (propertyAttrs.Length == 0)
					continue;

                List<Object> propertyAttrList = propertyAttrs.ToList();

				SourceRefAttribute sourceRef = (SourceRefAttribute)propertyAttrList.OfType<SourceRefAttribute>().SingleOrDefault();
				if (sourceRef == null || !globalSources.ContainsKey(sourceRef.SourceRefId)) {
					throw new Exception ();
				}

				string sourceText = globalSources[sourceRef.SourceRefId];
				bool foundValue = true;
				foreach (Attribute textActionAttribute in propertyAttrList.OfType<TextActionInterface>().OrderBy(x => x.Index)) {
					if((textActionAttribute is PropertyCaptureAttribute) && foundValue)
					{
						PropertyCaptureAttribute capture = (PropertyCaptureAttribute)textActionAttribute;
						Match match = Regex.Match(sourceText, capture.CaptureExpression, RegexOptions.IgnoreCase);

						if (match.Success) {
							string key = match.Groups [capture.Group].Value;
							sourceText = key;
						} else if (capture.IsOptional) {
							foundValue = false;
						} else {
							throw new Exception ();
						}
					}
				}

				if (!foundValue) {
					DefaultValueAttribute defaultValue = (DefaultValueAttribute)propertyAttrList.OfType<DefaultValueAttribute>().SingleOrDefault();
					if (defaultValue != null) {
						sourceText = defaultValue.Value;
					}
				}

				property.SetValue (objectToFill, sourceText, null);
			}

			return objectToFill;
		}

		private void FinishWebRequest(IAsyncResult result)
		{
            Tuple<int, HttpWebRequest> request2IdMap = result.AsyncState as Tuple<int, HttpWebRequest>;
            HttpWebRequest request = request2IdMap.Item2;
            Object responseAsObject = request.EndGetResponse(result);
            HttpWebResponse response = responseAsObject as HttpWebResponse;
			using (System.IO.Stream responseStream = response.GetResponseStream ()) {
				using (var reader = new System.IO.StreamReader (responseStream)) {
					pageText = reader.ReadToEnd ();

                    //allDone.Reset();

					//allDone.Set();
				}
			}

		}
	}


}

