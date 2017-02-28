--Accel Vocaloid Kyarone Ruru
function c5717748.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--synthetic synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5717748.syncon)
	e2:SetOperation(c5717748.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO+260)
	c:RegisterEffect(e2)
	--synthetic synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0xd72)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5717748,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c5717748.thcon)
	e5:SetTarget(c5717748.thtg)
	e5:SetOperation(c5717748.thop)
	c:RegisterEffect(e5)
	--defense attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DEFENSE_ATTACK)
	e6:SetCondition(c5717748.defatkcon)
	c:RegisterEffect(e6)
end
function c5717748.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac406)
end
function c5717748.defatkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5717748.confilter,tp,LOCATION_SZONE,0,2,nil)
end
function c5717748.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c5717748.customfilter(c)
	return c:IsSetCard(0xd71) or c:IsType(TYPE_NORMAL)
end
function c5717748.synfilter1(c,syncard,lv,g)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if not c:IsRace(RACE_MACHINE) or not c5717748.customfilter(c) then return false end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c5717748.synfilter2,1,nil,syncard,lv-tlv,wg)
end
function c5717748.synfilter2(c,syncard,lv,g)
	if not c:IsSetCard(0x0dac405) or not c:IsType(TYPE_TUNER) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	return g:IsExists(c5717748.synfilter3,1,c,syncard,lv-tlv)
end
function c5717748.synfilter3(c,syncard,lv)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return c:IsNotTuner() and (lv1==lv or lv2==lv)
end
function c5717748.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c5717748.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	if tuner then return c5717748.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c5717748.synfilter1,1,nil,c,lv,mg)
end
function c5717748.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c5717748.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c5717748.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	lv=lv-m1:GetSynchroLevel(c)
	mg:RemoveCard(m1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c5717748.synfilter2,1,1,nil,c,lv,mg)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetSynchroLevel(c)
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c5717748.synfilter3,1,1,nil,c,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
end
function c5717748.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:GetSummonType()==SUMMON_TYPE_SYNCHRO+260
end
function c5717748.thfilter(c)
	return bit.band(c:GetReason(),REASON_SYNCHRO)==REASON_SYNCHRO and c:IsAbleToHand()
end
function c5717748.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c5717748.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c5717748.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c5717748.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c5717748.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end