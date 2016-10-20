--The Future Gear Hourglass
function c99199030.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199030.splimit)
	e2:SetCondition(c99199030.splimcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199030,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,99199030)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c99199030.spcon)
	e3:SetTarget(c99199030.sptg)
	e3:SetOperation(c99199030.spop)
	c:RegisterEffect(e3)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c99199030.sccon)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99199030,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99199030.atkcon)
	e6:SetOperation(c99199030.atkop)
	c:RegisterEffect(e6)
end
function c99199030.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199030.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199030.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199030.spefilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and not c:IsCode(99199030)
end
function c99199030.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99199030.spefilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99199030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199030.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c99199030.spefilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e1,true)
	end
end
function c99199030.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsAttribute(ATTRIBUTE_LIGHT) and bit.band(at:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99199030.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		at:RegisterEffect(e1)
	end
end