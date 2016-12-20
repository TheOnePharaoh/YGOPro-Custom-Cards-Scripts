--Hellformed Girl Elsa
function c77777760.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77777760)
	e2:SetCost(c77777760.pencost)
	e2:SetTarget(c77777760.pentg)
	e2:SetOperation(c77777760.penop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777760,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c77777760.cost)
	e3:SetCountLimit(1,77777760+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c77777760.target)
	e3:SetOperation(c77777760.operation)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777760,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77777760.cost)
	e4:SetCountLimit(1,77777760+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c77777760.sstg)
	e4:SetOperation(c77777760.ssop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c77777760.spcon)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c77777760.splimit)
	c:RegisterEffect(e6)	
end

function c77777760.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FIEND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777760.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c77777760.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c77777760.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c77777760.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c77777760.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c77777760.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end

function c77777760.penfilter(c)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_PENDULUM) and not c:IsCode(77777760) and not c:IsForbidden()
end

function c77777760.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77777760.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777760.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777760.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777760.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777760.filter(c)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c77777760.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c77777760.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777760.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777760.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c77777760.ssfilter(c,e,tp)
	return c:IsSetCard(0x3e7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end