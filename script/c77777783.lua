--Aetherial Witchcrafter Isabeau
function c77777783.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777783,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c77777783.spcon)
	e1:SetTarget(c77777783.sptg)
	e1:SetOperation(c77777783.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777783.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777783,3))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777783.scop)
	c:RegisterEffect(e3)
	--special summon from hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(77777783,0))
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777783.target)
	e4:SetOperation(c77777783.operation)
	c:RegisterEffect(e4)
end

function c77777783.spfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and (c:IsSetCard(0x144)or c:IsSetCard(0x407))
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c77777783.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777783.spfilter,1,nil,tp)
end
function c77777783.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777783.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if  Duel.IsExistingMatchingCard(c77777783.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			local g=Duel.GetMatchingGroup(c77777783.xyzfilter,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		end
	end
end

function c77777783.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function c77777783.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777783.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end

function c77777783.spfilter2(c,e,tp)
	return (c:IsSetCard(0x144)or c:IsSetCard(0x407)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777783.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777783.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77777783.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777783.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end