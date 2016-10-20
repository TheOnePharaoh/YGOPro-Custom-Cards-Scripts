--The Future Gear Anna
function c99199029.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199029.splimit)
	e2:SetCondition(c99199029.splimcon)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c99199029.sccon)
	e3:SetValue(4)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199029,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c99199029.specost)
	e5:SetTarget(c99199029.spetg)
	e5:SetOperation(c99199029.speop)
	c:RegisterEffect(e5)
	--fusion
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c99199029.indcon1)
	e6:SetOperation(c99199029.indop)
	c:RegisterEffect(e6)
	--synchro
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetCondition(c99199029.indcon2)
	e7:SetOperation(c99199029.indop)
	c:RegisterEffect(e7)
	--xyz
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_BE_MATERIAL)
	e8:SetCondition(c99199029.indcon3)
	e8:SetOperation(c99199029.indop)
	c:RegisterEffect(e8)
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199029,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c99199029.spcon)
	e2:SetTarget(c99199029.sptg)
	e2:SetOperation(c99199029.spop)
	c:RegisterEffect(e2)
end
function c99199029.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199029.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199029.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199029.indcon1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c99199029.indcon2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c99199029.indcon3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c99199029.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99199029,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c99199029.damcon)
	e2:SetOperation(c99199029.damop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2)
end
function c99199029.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsDefensePos()
end
function c99199029.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c99199029.specost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c99199029.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199029.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c99199029.destrofilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c99199029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199029.destrofilter,1,nil,tp)
end
function c99199029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end