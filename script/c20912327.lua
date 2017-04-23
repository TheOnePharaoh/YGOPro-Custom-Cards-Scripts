--Sword Art Champion Miss Alleria
function c20912327.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912327,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(2)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c20912327.tuncon)
	e2:SetTarget(c20912327.tuntg)
	e2:SetOperation(c20912327.tuntop)
	c:RegisterEffect(e2)
end
function c20912327.tuncon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xd0a2)
end
function c20912327.tunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c20912327.tuntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912327.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912327.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20912327.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=1
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=1,4 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c20912327.tuntop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
	end
end