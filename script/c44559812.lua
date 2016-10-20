--Sun Wukong, Rebel God of the Sky Nirvana
function c44559812.initial_effect(c)
	c:SetUniqueOnField(1,0,44559812)
	c:SetCounterLimit(0x1109,6)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559812.tgvalue)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c44559812.poscon)
	e4:SetTarget(c44559812.postg)
	e4:SetOperation(c44559812.posop)
	c:RegisterEffect(e4)
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(44559812,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c44559812.ctcon)
	e5:SetOperation(c44559812.ctop)
	c:RegisterEffect(e5)
	--draw&discard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559812,1))
	e6:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCountLimit(1,44559812)
	e6:SetCost(c44559812.cost1)
	e6:SetTarget(c44559812.tg1)
	e6:SetOperation(c44559812.op1)
	c:RegisterEffect(e6)
	--destroy&banish
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(44559812,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,44559812)
	e7:SetCost(c44559812.cost2)
	e7:SetTarget(c44559812.tg2)
	e7:SetOperation(c44559812.op2)
	c:RegisterEffect(e7)
	--destroy&damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(44559812,3))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,44559812)
	e8:SetCost(c44559812.cost3)
	e8:SetTarget(c44559812.tg3)
	e8:SetOperation(c44559812.op3)
	c:RegisterEffect(e8)
end
function c44559812.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559812.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559812.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c44559812.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832)
end
function c44559812.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559812.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c44559812.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c44559812.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c44559812.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c44559812.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	local g=Duel.GetMatchingGroup(c44559812.filter,tp,0,LOCATION_MZONE,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.ChangePosition(dg,POS_FACEDOWN_DEFENSE)
	end
end
function c44559812.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c44559812.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1109,1)
end
function c44559812.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1109,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1109,2,REASON_COST)
end
function c44559812.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c44559812.op1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c44559812.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1109,4,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1109,4,REASON_COST)
end
function c44559812.asfilter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsAbleToRemove()
end
function c44559812.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44559812.asfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44559812.asfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c44559812.asfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c44559812.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		if not tc:IsAttribute(ATTRIBUTE_EARTH) then
			local code=tc:GetCode()
			local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,nil,code)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g)
			g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		end
	end
end
function c44559812.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1109,6,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1109,6,REASON_COST)
end
function c44559812.dfilter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c44559812.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559812.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c44559812.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c44559812.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c44559812.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local tc=dg:GetFirst()
	local dam=0
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		dam=dam+atk
		tc=dg:GetNext()
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end