private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
{
	if (e.Button == MouseButtons.Left)
	{
		Bitmap JPEG = new Bitmap(this.pictureBox1.Image);
		Int32 hh = JPEG.Height / 4;
		Int32 ww = JPEG.Width / 4;
		Bitmap NewBitmap = new Bitmap(ww, hh);
		Graphics sdf = Graphics.FromImage(NewBitmap);
		sdf.Clear(Color.Transparent);
		Rectangle asaadf = new Rectangle(0, 0, ww, hh);
		sdf.DrawImage(JPEG, asaadf);
		sdf.Save();
		Cursor asdf = new Cursor(NewBitmap.GetHicon());
		pictureBox1.Cursor = asdf;
	}
	else
	{
		//this.pictureBox1.Image = global::teamPart.Properties.Resources.;
		pictureBox1.Cursor = Cursors.Hand;
	}
}

private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
{
	string CurrentAppDir = System.AppDomain.CurrentDomain.BaseDirectory;
	string CSName = Guid.NewGuid().ToString();
	string fileName = CurrentAppDir + "\\" + CSName + ".ms";
	try
	{
		StringBuilder maxScriptsCode = new StringBuilder();
		maxScriptsCode.Append("print \"hello world\"");
		FileStream tempFile = new FileStream(fileName, FileMode.OpenOrCreate, FileAccess.ReadWrite);
		StreamWriter sw = new StreamWriter(tempFile);
		sw.WriteLine(maxScriptsCode.ToString());
		sw.Flush();
		sw.Close();
		tempFile.Close();
		string[] files = new string[1];
		files[0] = fileName;
		DataObject data = new DataObject(DataFormats.FileDrop, files);
		data.SetData(DataFormats.StringFormat, files[0]);
		((System.Windows.Forms.Control)sender).DoDragDrop(data, DragDropEffects.Link);
	}
	catch (Exception ee)
	{
		System.Windows.Forms.MessageBox.Show(ee.Message);
	}
	finally
	{
		pictureBox1.Cursor = Cursors.Default;
		if (System.IO.File.Exists(fileName))
		{
			System.IO.File.Delete(fileName);
		}
	}
}