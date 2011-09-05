package org.swizframework.aop.interceptor
{
    import mx.core.IFactory;

    import org.swizframework.aop.support.AdvisorChain;

    public class ProxyMethodFactory implements IFactory
    {
        private var chain:AdvisorChain;

        public function ProxyMethodFactory( chain:AdvisorChain )
        {
            this.chain = chain;
        }


        public function newInstance():*
        {
            return new ProxyMethod( chain );
        }
    }
}
