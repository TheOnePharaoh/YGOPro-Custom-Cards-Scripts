--The Idol Master of Tricky Devil Alice
function c59821069.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821069,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,59821069)
	e1:SetCost(c59821069.ritalcost)
	e1:SetTarget(c59821069.ritualtg)
	e1:SetOperation(c59821069.ritualop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821069.splimit)
	e2:SetCondition(c59821069.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821069.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--heal
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c59821069.reccon)
	e4:SetTarget(c59821069.rectg)
	e4:SetOperation(c59821069.recop)
	c:RegisterEffect(e4)
end
function c59821069.ritalcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c59821069.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xa1a2) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c59821069.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) and not c:IsType(TYPE_RITUAL) and not c:IsType(TYPE_XYZ) and c:IsAbleToGrave()
end
function c59821069.ritualtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c59821069.matfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c59821069.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_DECK)
end
function c59821069.ritualop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c59821069.matfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c59821069.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c59821069.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821069.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821069.tg(e,c)
	return c:IsSetCard(0xa1a2)
end
function c59821069.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821069.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c59821069.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end