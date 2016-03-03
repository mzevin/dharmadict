namespace Core.Bootstrap
{
    public static class ApplicationFactory
    {
        private static Application instance;
        private static readonly object lockObj = new object();

        public static T CreateApplication<T>() where T : Application, new()
        {
            if (instance != null)
                return (T)instance;

            lock (lockObj)
            {
                if (instance == null)
                    instance = new T();
                return (T)instance;
            }
        }

        public static Application Application
        {
            get { return instance; }
        }
    }
}