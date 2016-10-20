--Vocaloid Prima
function c41885390.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41885390,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(2)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c41885390.damcon)
	e2:SetTarget(c41885390.damtg)
	e2:SetOperation(c41885390.damop)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(41885390,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c41885390.target)
	e3:SetOperation(c41885390.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c41885390.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE)
end
function c41885390.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c41885390.filter,1,nil,tp)
end
function c41885390.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c41885390.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c41885390.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c41885390.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41885390.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c41885390.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c41885390.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
