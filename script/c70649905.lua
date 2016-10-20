--ADE Pegasis
function c70649905.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649905,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,70649905)
	e1:SetTarget(c70649905.sumtg)
	e1:SetOperation(c70649905.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70649905,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCondition(c70649905.descon)
	e4:SetTarget(c70649905.destg)
	e4:SetOperation(c70649905.desop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(70649905,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c70649905.condition)
	e5:SetTarget(c70649905.target)
	e5:SetOperation(c70649905.operation)
	c:RegisterEffect(e5)
end
function c70649905.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(70649905) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70649905.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70649905.filter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c70649905.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c70649905.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c70649905.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetTurnPlayer()~=tp
end
function c70649905.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst()~=e:GetHandler() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c70649905.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c70649905.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649905.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1300)
end
function c70649905.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
