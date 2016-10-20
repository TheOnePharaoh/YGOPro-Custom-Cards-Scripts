--Chaos Witch Quelaag
--lua script by SGJin
function c12310732.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--ATK up for each Humanity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12310732.val)
	c:RegisterEffect(e1)
	--Burn Damage (Chaos Flame)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35809262,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c12310732.damcon)
	e2:SetTarget(c12310732.damtg)
	e2:SetOperation(c12310732.damop)
	c:RegisterEffect(e2)
	--Drops 2 Humanities
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310706,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12310732.thcon)
	e3:SetTarget(c12310732.thtg)
	e3:SetOperation(c12310732.thop)
	c:RegisterEffect(e3)
end
function c12310732.filter2(c)
	return c:IsCode(12310712) and c:IsHasEffect(12310713)
end
function c12310732.val(e,c)
	local batk=Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,12310712)*400
	local twinatk=Duel.GetMatchingGroupCount(c12310732.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)*400
	return batk + twinatk
end
function c12310732.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c12310732.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c12310732.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c12310732.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310732.filter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310732.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310732.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310732.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310732.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
