--TG ジェット・ファルコン
function c512000028.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37300735,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c512000028.damcon)
	e1:SetTarget(c512000028.damtg)
	e1:SetOperation(c512000028.damop)
	c:RegisterEffect(e1)
	--Type Machine
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--Add to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000073,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c512000028.scon)
	e3:SetTarget(c512000028.stg)
	e3:SetOperation(c512000028.sop)
	c:RegisterEffect(e3)
end
function c512000028.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c512000028.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c512000028.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c512000028.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c512000028.sfilter(c)
	return c:IsCode(37300735) and c:IsAbleToHand()
end
function c512000028.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000028.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c512000028.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c512000028.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
