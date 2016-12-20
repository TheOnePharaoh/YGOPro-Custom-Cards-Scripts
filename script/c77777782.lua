--Aetherial Witchcrafter Isabeau
function c77777782.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777782,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c77777782.spcon)
	e1:SetTarget(c77777782.sptg)
	e1:SetOperation(c77777782.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777782.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777782,3))
	e3:SetCountLimit(1)
	e3:SetOperation(c77777782.scop)
	c:RegisterEffect(e3)
	--Destroy card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777708,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,77777782)
	e6:SetCost(c77777782.cost)
	e6:SetTarget(c77777782.destg)
	e6:SetOperation(c77777782.desop)
	c:RegisterEffect(e6)
end

function c77777782.spfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and (c:IsSetCard(0x144)or c:IsSetCard(0x407))
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c77777782.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777782.spfilter,1,nil,tp)
end
function c77777782.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77777782.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if  Duel.IsExistingMatchingCard(c77777782.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			local g=Duel.GetMatchingGroup(c77777782.xyzfilter,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		end
	end
end

function c77777782.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function c77777782.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER)and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c77777782.scop(e,tp,eg,ep,ev,re,r,rp)
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

function c77777782.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x407)or c:IsSetCard(0x144)) and c:IsDestructable() 
	and  (c:GetSequence()==6 or c:GetSequence()==7)
end
function c77777782.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777782.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77777782.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c77777782.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777782.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end