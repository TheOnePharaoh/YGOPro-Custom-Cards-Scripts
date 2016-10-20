--Manus - Father of the Abyss
--lua script by SGJin
function c12310736.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR+RACE_SPELLCASTER),8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12310736.splimit)
	c:RegisterEffect(e1)
	--Summon Success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c12310736.sumsuc)
	c:RegisterEffect(e2)
	--Cannot banish any cards (Father of the Abyss)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e3)
 	local e4=Effect.CreateEffect(c)
 	e4:SetType(EFFECT_TYPE_FIELD)
 	e4:SetCode(30459350)
	e4:SetRange(LOCATION_MZONE)
 	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
 	e4:SetTargetRange(1,1)
 	c:RegisterEffect(e4)
	--Negates monster Effects
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12310736,0))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1)
	e5:SetCondition(c12310736.discon)
	e5:SetCost(c12310736.discost)
	e5:SetTarget(c12310736.distg)
	e5:SetOperation(c12310736.disop)
	c:RegisterEffect(e5)
	--Return Humanity & Drops Humanity
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12310736,0))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c12310736.thcon)
	e6:SetTarget(c12310736.thtg)
	e6:SetOperation(c12310736.thop)
	c:RegisterEffect(e6)
end
function c12310736.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c12310736.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c12310736.discon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c12310736.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310736.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function c12310736.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1500,REASON_EFFECT)
	end
end
function c12310736.filter(c)
	return c:IsCode(12310712) or c:IsCode(12310713) or c:IsCode(12310730)
end
function c12310736.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310736.filter2(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310736.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c12310736.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12310736.filter,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310736.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
