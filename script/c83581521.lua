--Beast of Wild - Tree Summoner
function c83581521.initial_effect(c)
	c:SetSPSummonOnce(83581521)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c83581521.splimit)
	e1:SetCondition(c83581521.splimcon)
	c:RegisterEffect(e1)
	--atkmod
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c83581521.atktg)
	e2:SetValue(400) 
	c:RegisterEffect(e2)
	--draw1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83581521,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,83581521)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c83581521.drcost1)
	e3:SetTarget(c83581521.drtg1)
	e3:SetOperation(c83581521.drop1)
	c:RegisterEffect(e3)
	--draw2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(83581521,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,83581521)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c83581521.drcost2)
	e4:SetTarget(c83581521.drtg2)
	e4:SetOperation(c83581521.drop2)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(83581521,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c83581521.spcon)
	e5:SetTarget(c83581521.sptg)
	e5:SetOperation(c83581521.spop)
	c:RegisterEffect(e5)
end
function c83581521.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x12c) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c83581521.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c83581521.atktg(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:GetSummonLocation()==LOCATION_HAND or c:GetSummonLocation()==LOCATION_EXTRA
end
function c83581521.costfilter(c)
	return c:IsSetCard(0x12c) and c:IsDestructable()
end
function c83581521.drcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83581521.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c83581521.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c83581521.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c83581521.drop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c83581521.drcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83581521.costfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c83581521.costfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.Destroy(g,REASON_COST)
end
function c83581521.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c83581521.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c83581521.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c83581521.spfilter(c,e,tp,satk)
	local atk=c:GetAttack()
	return atk>=0 and (not satk or atk==satk) and c:IsSetCard(0x12c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83581521.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if ft==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
			return Duel.IsExistingMatchingCard(c83581521.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,3000)
		else
			local g=Duel.GetMatchingGroup(c83581521.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,e:GetHandler(),e,tp)
			return g:CheckWithSumEqual(Card.GetAttack,3000,1,2)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c83581521.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c83581521.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,3000)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local g=Duel.GetMatchingGroup(c83581521.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if g:CheckWithSumEqual(Card.GetAttack,3000,1,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectWithSumEqual(tp,Card.GetAttack,3000,1,2)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end