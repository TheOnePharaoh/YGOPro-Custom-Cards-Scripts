--Dark Paladin of Spells
--lua script by SGJin
function c98502110.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),8,2,c98502110.ovfilter,aux.Stringid(98502110,0))
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98502110.splimit)
	c:RegisterEffect(e1)
	--Ultimate Spell Hate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98502110,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c98502110.negcon)
	e2:SetCost(c98502110.negcost)
	e2:SetTarget(c98502110.negtg)
	e2:SetOperation(c98502110.negop)
	c:RegisterEffect(e2)
	--ATK +
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c98502110.val)
	c:RegisterEffect(e3)
end
function c98502110.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c98502110.ovfilter(c)
	return c:IsFaceup() and (c:GetRank()==6 or c:GetRank()==7) and c:IsRace(RACE_SPELLCASTER)
end
function c98502110.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL)*100
end
function c98502110.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c98502110.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98502110.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c98502110.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c98502110.aclimit)
		e1:SetLabel(re:GetHandler():GetCode())
		Duel.RegisterEffect(e1,tp)
	end
end
function c98502110.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
