--Vocaloid Haku Yowane - The Daughter of White
function c82345.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,7615134),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c82345.efilter)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82345,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c82345.sptg)
	e3:SetOperation(c82345.spop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82345.damcon)
	e4:SetOperation(c82345.damop)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c82345.indes)
	c:RegisterEffect(e5)
	--nontuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetTarget(c82345.target)
	e7:SetOperation(c82345.operation)
	c:RegisterEffect(e7)
end
function c82345.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c82345.mfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82345.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c82345.mfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82345.mfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82345.mfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c82345.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_MACHINE)
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(82345,RESET_EVENT+0x1fe0000,0,0)
		c:RegisterFlagEffect(82345,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c82345.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:IsRelateToBattle() and eg:GetFirst()==c:GetBattleTarget()
end
function c82345.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev,false)
end
function c82345.indes(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c82345.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c82345.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82345.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82345.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c82345.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c82345.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end
