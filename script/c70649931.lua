--ADE Nif
function c70649931.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c70649931.splimit)
	e2:SetCondition(c70649931.splimcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70649931,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c70649931.spcon)
	e3:SetTarget(c70649931.sptg)
	e3:SetOperation(c70649931.spop)
	c:RegisterEffect(e3)
end
function c70649931.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c70649931.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c70649931.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_TUNER)
end
function c70649931.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70649931.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c70649931.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70649931.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end