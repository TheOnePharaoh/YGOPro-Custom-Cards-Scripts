--Otoshiro Seira
function c59821008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821008.splimit)
	e2:SetCondition(c59821008.splimcon)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c59821008.val)
	c:RegisterEffect(e4)
	--cannot be battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetTarget(c59821008.atlimit)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821008,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCountLimit(1,59821008)
	e6:SetCondition(c59821008.condition)
	e6:SetTarget(c59821008.target)
	e6:SetOperation(c59821008.operation)
	c:RegisterEffect(e6)
	--cannot direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e7)
	--only 1 can exists
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_SUMMON)
	e8:SetCondition(c59821008.exccon)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e10)
end
function c59821008.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821008.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821008.val(e,c)
	return Duel.GetMatchingGroupCount(c59821008.filter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c59821008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821008.atlimit(e,c)
	return c:IsFaceup() and c~=e:GetHandler() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049) or c:IsCode(59821085)
end
function c59821008.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821008.filter2(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c59821008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821008.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821008.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c59821008.excfilter(c)
	return c:IsFaceup() and c:IsCode(59821008)
end
function c59821008.exccon(e)
	return Duel.IsExistingMatchingCard(c59821008.excfilter,0,LOCATION_MZONE,0,1,nil)
end