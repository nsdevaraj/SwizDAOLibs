package com.adams.swizdao.util { 
	import com.coltware.airxmail.AirxMailConfig;
	import com.coltware.airxmail.ContentType;
	import com.coltware.airxmail.INetAddress;
	import com.coltware.airxmail.MimeImagePart;
	import com.coltware.airxmail.MimeMessage;
	import com.coltware.airxmail.MimeTextPart;
	import com.coltware.airxmail.RecipientType;
	import com.coltware.airxmail.MailSender.SMTPSender;
	import com.hurlant.crypto.tls.TLSSocket;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.osflash.signals.Signal;
	
	public class SMTPUtil
	{
		public static var mailStatus:Signal = new Signal();
		public static var mailId:String = "devaraj.ns@cognizant.com";
		public static function sendEmail(filePath:String,email:String,image:Boolean=true):void
		{
			var sender:SMTPSender = new SMTPSender();
			sender.setParameter(SMTPSender.HOST,"smtp.gmail.com");
			sender.setParameter(SMTPSender.PORT,465);
			sender.setParameter(SMTPSender.AUTH,true);
			sender.setParameter(SMTPSender.USERNAME,"awcoe.cts");
			sender.setParameter(SMTPSender.PASSWORD,"awcoe!ncts");
			sender.setParameter(SMTPSender.SOCKET_OBJECT,new TLSSocket());
			sender.addEventListener("smtpAuthOk", authOK);
			sender.addEventListener("smtpConnectionFailed", errorHandler);
			sender.addEventListener("smtpSentOk",allOK);
			
			// use STARTTLS
			AirxMailConfig.setDefaultHeaderCharset("UTF-8");
			var contentType:ContentType = ContentType.MULTIPART_MIXED;	
			var mimeMsg:MimeMessage = new MimeMessage(contentType);
			
			var from:INetAddress = new INetAddress();
			from.personal = "Glitz App";
			from.address = "awcoe.cts@gmail.com";
			
			mimeMsg.setFrom(from);
			var toAddr:INetAddress = new INetAddress(email,"Devaraj");
			mimeMsg.addRcpt(RecipientType.TO,toAddr);
			// set mail subject
			if(image){
				mimeMsg.setSubject("Glitz Trial");
				var textPart:MimeTextPart = new MimeTextPart();
				textPart.contentType.setParameter("charset","UTF-8");
				textPart.transferEncoding = "8bit";
				textPart.setText("This is your Glitz trial image");
				mimeMsg.addChildPart(textPart);
				var filePart:MimeImagePart = new MimeImagePart();
				filePart.contentType.setMainType("image");
				filePart.contentType.setSubType("jpeg");
				filePart.setAttachementFile(new File(filePath), "GlitzTrial.jpg");
				mimeMsg.addChildPart(filePart);
			}else{
				mimeMsg.setSubject("Glitz Log");
				var textParts:MimeTextPart = new MimeTextPart();
				textParts.contentType.setParameter("charset","UTF-8");
				textParts.transferEncoding = "8bit";
				textParts.setText("This is your Glitz bug log");
				mimeMsg.addChildPart(textParts);
				var fileParts:MimeImagePart = new MimeImagePart();
				fileParts.contentType.setMainType("text");
				fileParts.contentType.setSubType("plain");
				fileParts.setAttachementFile(new File(filePath), "GlitzLog.txt");
				mimeMsg.addChildPart(fileParts);
			}
			sender.send(mimeMsg);
			sender.close();
		}
		
		protected static function errorHandler(event:Event):void{
			trace('error');
			mailStatus.dispatch(event);
		}
		
		protected static function authOK(event:Event):void{
			trace('auth OK');
		}
		
		protected static function allOK(event:Event):void{
			mailStatus.dispatch(event);
		}
	}
}