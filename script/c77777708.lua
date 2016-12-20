--Witchcrafter Kimmy
function c77777708.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(aux.nfbdncon)
	e2:SetTarget(c77777708.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777708,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777708.sccon)
--	e3:SetTarget(c77777708.sctg)
	e3:SetOperation(c77777708.scop)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(-200)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x407))
	e5:SetValue(200)
	c:RegisterEffect(e5)
	--Search for S/T
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777708,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCost(c77777708.cost)
	e6:SetTarget(c77777708.target)
	e6:SetOperation(c77777708.operation)
	c:RegisterEffect(e6)
	
end

function c77777708.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777708.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77777708.scop(e,tp,eg,ep,ev,re,r,rp)
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
function c77777708.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x407) and c:IsDestructable() 
	and  (c:GetSequence()==6 or c:GetSequence()==7)
end
function c77777708.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777708.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77777708.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c77777708.filter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77777708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777708.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777708.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777708.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
