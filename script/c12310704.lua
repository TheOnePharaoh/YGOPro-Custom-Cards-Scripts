--Black Dragon Kalameet
--lua script by SGJin
function c12310704.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12310704.splimit)
	c:RegisterEffect(e1)
	--Piercing (Black Flame)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(c12310704.atkcon)
	c:RegisterEffect(e2)
	--Double battle damage of next attack (Mark of Calamity)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310704,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12310704.damcost)
	e3:SetOperation(c12310704.damop)
	c:RegisterEffect(e3)
	--Chance to Drop Humanity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310704,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310704.thcon)
	e4:SetTarget(c12310704.thtg)
	e4:SetOperation(c12310704.thop)
	c:RegisterEffect(e4)
end
function c12310704.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c12310704.atkcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c12310704.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c12310704.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c12310704.rdop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12310704.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev*2)
end
function c12310704.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310704.filter(c)
	return c:IsCode(12310712) and c:IsAbleToHand()
end
function c12310704.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310704.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12310704.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310704.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
