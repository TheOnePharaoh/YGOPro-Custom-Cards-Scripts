--The Future Gear Sorcerer Shin
function c99199002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199002.splimit)
	e2:SetCondition(c99199002.splimcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199002,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c99199002.spcon)
	e3:SetTarget(c99199002.sptg)
	e3:SetOperation(c99199002.spop)
	c:RegisterEffect(e3)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c99199002.sccon)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--Change Level
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99199002,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetTarget(c99199002.thtg)
	e6:SetOperation(c99199002.thop)
	c:RegisterEffect(e6)
end
function c99199002.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199002.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199002.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c99199002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199002.cfilter,1,nil,tp)
end
function c99199002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99199002.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199002.thfil(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xff15)
end
function c99199002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199002.thfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c99199002.thfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c99199002.thfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local t={}
	local i=1
	local p=1
	for i=1,8 do
		t[p]=i
		p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199002,2))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c99199002.lvfil(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c99199002.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c99199002.lvfil,nil,e)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199002.splimit)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c99199002.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xff15)
end
