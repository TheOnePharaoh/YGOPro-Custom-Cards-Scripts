--Witchcrafter Rosebud
function c77777710.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777710.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777710,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777710.sccon)
--	e3:SetTarget(c77777710.sctg)
	e3:SetOperation(c77777710.scop)
	c:RegisterEffect(e3)
	--PZ Unaffected by card effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCondition(c77777710.uncon)
	e4:SetTarget(c77777710.indtg)
	e4:SetValue(c77777710.efilter)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
	--effect gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c77777710.efcon)
	e6:SetOperation(c77777710.efop)
	c:RegisterEffect(e6)
	
end

function c77777710.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777710.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777710.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777710.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c77777710.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--search
	local e2=Effect.CreateEffect(rc)
	e2:SetDescription(aux.Stringid(77777710,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,77777710)
	e2:SetCost(c77777710.hndcost)
	e2:SetTarget(c77777710.hndtarget)
	e2:SetOperation(c77777710.hndoperation)
	rc:RegisterEffect(e2,true)
end

function c77777710.hndcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function c77777710.filter2(c)
	return c:IsSetCard(0x407) and c:IsAbleToHand()
end
function c77777710.hndtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777710.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777710.hndoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777710.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c77777710.uncon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return (c:GetLeftScale()==c:GetOriginalLeftScale()) and (c:GetRightScale()==c:GetOriginalRightScale())
end
function c77777710.indtg(e,c)
	return c:IsSetCard(0x407) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c77777710.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
