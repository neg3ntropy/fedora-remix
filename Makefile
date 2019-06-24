FLAVOR=kde-tierra
RELEASEVER=29

ODIR=results

images: $(ODIR)/$(FLAVOR)/images/boot-efi.iso $(ODIR)/$(FLAVOR)/images/boot.iso

$(ODIR)/$(FLAVOR)/images/boot-efi.iso: $(ODIR)/$(FLAVOR)/images/boot.iso
	cat $(ODIR)/$(FLAVOR)/images/boot.iso $(ODIR)/$(FLAVOR)/images/efiboot.img > $(ODIR)/$(FLAVOR)/images/boot-efi.iso

$(ODIR)/$(FLAVOR)/images/boot.iso: $(ODIR)/$(FLAVOR)-flattened.ks
	cd $(ODIR); livemedia-creator --resultdir=$(FLAVOR) --make-iso --no-virt --project=Fedora --releasever=$(RELEASEVER) --ks=$(FLAVOR)-flattened.ks

$(ODIR)/$(FLAVOR)-flattened.ks: $(ODIR) $(wildcard kickstarts/*.ks)
	ksflatten --config kickstarts/$(FLAVOR).ks --output $(ODIR)/$(FLAVOR)-flattened.ks

$(ODIR):
	mkdir -p $(ODIR)

clean:
	rm -fr $(ODIR)

test: $(ODIR)/$(FLAVOR)/images/boot.iso
	qemu-kvm -m 1200 -cdrom $(ODIR)/$(FLAVOR)/images/boot-efi.iso
