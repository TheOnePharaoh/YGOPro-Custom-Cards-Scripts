--Dragon of the Black Art
function c77628919.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsSetCard,0xba003),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77628919,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c77628919.condition)
	e1:SetTarget(c77628919.target)
	e1:SetOperation(c77628919.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(77628919,1))
	e2:SetCondition(c77628919.condition2)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77628919.atkcon)
	e3:SetOperation(c77628919.atkop)
	c:RegisterEffect(e3)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c77628919.splimit)
	c:RegisterEffect(e4)
end
function c77628919.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c77628919.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:IsRace(RACE_ZOMBIE) and loc==LOCATION_MZONE
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77628919.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and tc:IsRace(RACE_ZOMBIE) and tc:IsLocation(LOCATION_MZONE)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77628919.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77628919.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then 
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c77628919.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler()==e:GetHandler()
		and eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c77628919.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local c=e:GetHandler()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		if tc:GetTextAttack()>0 then
			atk=atk+tc:GetTextAttack()
		end
		tc=g:GetNext()
	end
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
