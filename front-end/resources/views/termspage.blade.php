<link rel="stylesheet" href="{{ asset('css/general.css') }}">
<section class="inner">
		 {!! Form::open(['url' => route('accept.terms'), 'class' => 'form-read-terms', ]) !!}
		 <h2>SNS Team's Terms of Service</h2>
			<div class="span12">
		        <div class="page-header term">
		                <h2>1. General Terms</h2>
		        </div>
		        <p><strong>&bull;</strong> By accessing and placing an order with WrapBootstrap, you confirm that you are in agreement with and bound by the terms and conditions contained in the Terms Of Use outlined below. These terms apply to the entire website and any email or other type of communication between you and WrapBootstrap.</p>

		        <div class="page-header term">
		                <h2>2. Products</h2>
		        </div>
		        <p><strong>&bull;</strong> All products and services are delivered by WrapBootstrap electronically to your email address.</p>
		        <p><strong>&bull;</strong> WrapBootstrap is not responsible for any technological delays beyond our control. If your spam blocker blocks our emails from reaching you or you do not provide a valid email address where you can be reachable then you can access your download from the Purchases page.</p>

		        <div class="page-header term">
		                <h2>3. Security</h2>
		        </div>
		        <p><strong>&bull;</strong> WrapBootstrap does not process any order payments through the website. All payments are processed securely through PayPal, a third party online payment provider. Feel free to contact us about our security policies.</p>

		        <div class="page-header term">
		                <h2>4. Refunds</h2>
		        </div>
		        <p><strong>&bull;</strong> You have 24 hours to inspect your purchase and to determine if it does not meet with the expectations laid forth by the seller. In the event that you wish to receive a refund, WrapBootstrap will issue you a refund and ask you to specify how the product failed to live up to expectations.</p>

		        <div class="page-header term">
		                <h2>5. Ownership</h2>
		        </div>
		        <p><strong>&bull;</strong> Ownership of the product is governed by the usage license selected by the seller.</p>

		        <div class="page-header changes">
		                <h2>Changes to terms</h2>
		        </div>
		        <p>If we change our terms of use we will post those changes on this page. Registered users will be sent an email that outlines changes made to the terms of use.</p>
			</div>

			<div class="btnarea">
				<input type="submit" class="btn-custom" value="Accept" name="accept">
				<input type="submit" class="btn-custom" value="Decline" name="decline">
			</div>
		{!! Form::close() !!}
</section>
