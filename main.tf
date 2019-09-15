provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "nvnserver2" {
  ami           = "ami-02f706d959cedf892"
  instance_type = "t2.micro"
  #   key_name = "${file(var.aws_pvtkey)}"
  #key_name = "${var.aws_pubkey}"

  key_name = "nvn_aws_sept"
  #public_dns_name   =  true
  associate_public_ip_address = true
  subnet_id                   = "${aws_subnet.nvn_subnet.id}"

  vpc_security_group_ids = ["${aws_security_group.nvn_sg.id}"]

  tags = {
    Name = "nvnpocservertest"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.nvnserver2.public_ip} >> /root/nvn/outputtest.txt"
  }
}

/* inline test of SSH connection that file provisioner fails to utilize */
resource "null_resource" "localexec2" {
  depends_on = [aws_instance.nvnserver2]
  provisioner "local-exec" {
    #  command = "sleep 60; ssh -i ${var.aws_pvtkey} ec2-user@${aws_instance.nvnserver2.public_ip} 'echo hello from $(hostname)'"
    # command = "sleep 60; scp -i ${var.aws_pvtkey} /tmp/nvntest.txt ec2-user@${aws_instance.nvnserver2.public_ip}:/tmp"
    command = "date"
  }
}
########

###  ansible execution bloc

########

######## Copies the local file to remote server  ######
resource "null_resource" "file1" {
  depends_on = [aws_instance.nvnserver2]

  provisioner "file" {

    connection {
      type = "ssh"
      #host       =  "18.191.225.60"
      host        = "${aws_instance.nvnserver2.public_ip}"
      user        = "ec2-user"
      private_key = "${file(var.aws_pvtkey)}"
      agent       = false
      timeout     = "30s"
    }
    source      = "/root/nvn/nvntest.txt"
    destination = "/home/ec2-user/nvntest.txt"
  }
}
#######################
###### remote exxecution block #####
resource "null_resource" "remoteexec1" {
  depends_on = [aws_instance.nvnserver2, null_resource.file1]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${aws_instance.nvnserver2.public_ip}"
      # host       =  "18.191.225.60"
      user        = "ec2-user"
      private_key = "${file(var.aws_pvtkey)}"
      agent       = false
      timeout     = "30s"
    }

    inline = [
      "sudo mkdir /root/nvnfolder",
      "sudo chmod 777 /root/nvnfolder/",

    ]
  }
}

##########################


